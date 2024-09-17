package 'wget'

case node['platform_family']
when 'rhel'
  package 'openssl-libs'
end

directory node['setup']['download_dir'] do
  owner node['setup']['user']
  group node['setup']['group']
  recursive true
  action :create
end


def recursiveFlat(m)
  values = m.values
  ret_value = []
  values.each do |v|
    if v.is_a? Hash
      ret_value = ret_value | recursiveFlat(v)
    else
      ret_value << v
    end
  end
  ret_value
end

res = recursiveFlat(node)
res.each do |v|
  if v =~ /#{node['download_url']}.+/ || v =~ /https:\/\/repo.hops.works\/master\/.+/
    # want to match 'kube/docker-images/1.4.1 -  but not 'kube/docker-images/registry_image.tar'
    # if v =~ /kube\/docker-images\/[0-9]*.+/ && v =~ /#{node['install']['version']}.+/
    File.open("/tmp/download_links", "a") { |file| file.write("#{v}\n")}
  end
end
