package poacencur;

use Digest::MD5 qw( md5_hex md5 ); 

use Dancer ':syntax';
our $VERSION = '0.1';

get '/' => sub {
#            $message = 'Something went terribly wrong, but please try again!';

    template 'index';
};

post '/upload' => sub {
    my $file = request->upload('upload_img');

    if ( $file ){
        my $full_image_path;
        my $new_dir_name;
        eval {
            $new_dir_name = sprintf( '%s%s', time, md5_hex( rand ) );
            $full_image_path = config->{upload_path}.'/'.$new_dir_name;

            mkdir $full_image_path, 0755 || die 'nu fac niciun dir!!!';

            $file->copy_to($full_image_path.'/img.jpg');
        };
        if ($@){
            return redirect "/?what=nutesuparaaiavutoeroare";
        }

        #redirect to the image path if all is good
        return redirect "/view/$new_dir_name";
    }

    return redirect "/?what=nutesuparafratenuaifisier";

};

any '/view/:dir' => sub {
    my $dir = params->{dir};

    return redirect '/404' unless $dir;

    my $full_dir = config->{upload_path} . '/' . $dir;    
    my @list;

    return redirect '/404' unless( -e $full_dir );
    eval{
        opendir( D, "$full_dir" ) || die "Can't opedir $full_dir: $!\n";
        @list = readdir( D );
        closedir( D );
    };

    if( $@ || !$list[2] ){
        return redirect '/404';
    }

    template 'view' => {
        dir => $full_dir,
    };
};

any '/delete/:dir' => sub {
    my $dir = params->{dir};

    return redirect '/404' unless $dir;

    eval {
        my $full_path = config->{upload_path} .'/'.$dir;
        debug `rm -rf $full_path`;
        return redirect '/';
    };
    if ( $@ ){
        return redirect "/view/$dir";
    }
};

true;
