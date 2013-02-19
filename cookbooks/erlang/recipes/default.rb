ERLV = 'R15B01'

execute "download Erlang/OTP" do
  not_if "test -f /tmp/otp_src_#{ERLV}.tar.gz"
  command "wget http://www.erlang.org/download/otp_src_#{ERLV}.tar.gz -O /tmp/otp_src_#{ERLV}.tar.gz"
end

execute "unpack Erlang/OTP" do
  not_if "test -d /tmp/otp_src_#{ERLV}"
  command "tar xzf /tmp/otp_src_#{ERLV}.tar.gz -C /tmp"
end

unless `uname`.strip == 'Darwin'
  package "build-essential"
  package "libncurses5-dev openssl libssl-dev libsctp-dev libexpat1-dev"
end

script "build Erlang/OTP" do
  interpreter "bash"
  cwd "/tmp/otp_src_#{ERLV}"
  code <<-SH
  ./configure --enable-threads --enable-smp-support --enable-kernel-poll --enable-hipe --enable-sctp \
              #{"--with-ssl=/usr/lib/ssl/" unless `uname`.strip == 'Darwin'}
  make install
  SH
end

