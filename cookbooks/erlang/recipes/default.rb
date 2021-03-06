execute "download Erlang/OTP" do
  not_if "test -f /tmp/otp_src_R14B02.tar.gz"
  command "curl http://www.erlang.org/download/otp_src_R14B02.tar.gz -o /tmp/otp_src_R14B02.tar.gz"
end

execute "unpack Erlang/OTP" do
  not_if "test -d /tmp/otp_src_R14B02"
  command "tar xzf /tmp/otp_src_R14B02.tar.gz -C /tmp"
end

unless `uname`.strip == 'Darwin'
  
  package "mypackage-dev" do
  action "nothing"
  end.run_action(:install)
  
  package "libncurses5-dev openssl libssl-dev libsctp-dev libexpat1-dev" do
  action "nothing"
  end.run_action(:install)
  
end

script "build Erlang/OTP" do
  interpreter "bash"
  cwd "/tmp/otp_src_R14B02"
  code <<-SH
  CFLAGS=-O0 ./configure --enable-threads --enable-smp-support --enable-kernel-poll --enable-hipe --enable-sctp \
    #{"--with-ssl=/usr/lib/ssl/" unless `uname`.strip == 'Darwin'} #{"--enable-darwin-64bit" if `uname`.strip == 'Darwin'}
  make install
  SH
end