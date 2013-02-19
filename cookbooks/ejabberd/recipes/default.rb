EJABBV = "2.1.11"

script "download Ejabberd" do
  not_if "test -d /tmp/ejabberd-#{EJABBV}"
  interpreter "bash"
  cwd "/tmp"
  code <<-SH
  wget http://www.process-one.net/downloads/ejabberd/2.1.11/ejabberd-2.1.11.tgz
  tar xzf ejabberd-#{EJABBV}.tar.gz
  SH
end

unless `uname`.strip == 'Darwin'
  user "ejabberd" do
    not_if "grep ejabberd /etc/passwd"
    gid "ejabberd"
    system true
  end
end

script "build Ejabberd" do
  interpreter "bash"
  cwd "/tmp/ejabberd-#{EJABBV}/src"
  code <<-SH
  #{'INSTALLUSER=ejabberd' unless `uname`.strip == 'Darwin'} ./configure --prefix=''
  make install
  SH
end

template "/etc/ejabberd/ejabberd.cfg" do
  source "ejabberd.cfg"
  owner `uname`.strip == 'Darwin' ? "root" : "ejabberd"
  mode 0640
end

