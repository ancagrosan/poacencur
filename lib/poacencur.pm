package poacencur;

use Digest::MD5 qw( md5_hex md5 );
use Image::Scale;
use Try::Tiny;

use Dancer ':syntax';
our $VERSION = '0.1';

get '/' => sub {
    
    template 'index', { what => params->{what} };
};

post '/upload' => sub {
    my $file = request->upload('upload_img');
    my $redirect = "/?what=nutesuparafratenuaifisier";
    
    if( $file ){        
        if ( $file->filename() =~ /.*\.(png|jpg|jpeg|jfif|gif|bmp|svg|raw|tiff)/i ){
            try {
                my $full_image_path;
                my $new_dir_name;
                
                $new_dir_name = sprintf( '%s%s', time, md5_hex( rand ) );
                $full_image_path = config->{upload_path}.'/'.$new_dir_name;
                
                mkdir $full_image_path, 0755;
                
                my $full_path = $full_image_path.'/img.jpg';
                
                $file->copy_to($full_path);
                
                my $img = Image::Scale->new($full_path);
                $img->resize_gd( { width => 800 } );
                $img->save_jpeg($full_path);
    
                #redirect to the image path if all is good
                $redirect = "/view/$new_dir_name", 200;
            } catch {
                debug $@;
                $redirect = "/?what=nutesuparaaiavutoeroare";
            }
        } else {
            $redirect = "/?what=nutesuparaaiavutoeroare";
        }
    }
    
    return redirect $redirect;
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
