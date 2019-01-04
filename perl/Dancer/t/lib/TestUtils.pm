package TestUtils;

use base 'Exporter';
use vars '@EXPORT';

use File::Path qw(mkpath rmtree);
use Dancer::Request;
use HTTP::Tiny;

@EXPORT =
  qw(http_request write_file clean_tmp_files);

sub http_request {
    my ($port, $method, $path) = @_;
    my $url = "http://localhost:${port}${path}";
    my $http = HTTP::Tiny->new;
    return $http->request($method => $url);
}

sub write_file {
    my ($file, $content) = @_;

    open CONF, '>', $file or die "cannot write file $file : $!";
    print CONF $content;
    close CONF;
}

sub clean_tmp_files {
    my $appdir = setting('appdir') || File::Spec->tmpdir();
    my $logs_dir = File::Spec->catdir($appdir, 'logs');
    rmtree($logs_dir) if -d $logs_dir;

    my $sessions = setting session_dir;
    rmtree($sessions) if $sessions && -d $sessions;
}

1;
