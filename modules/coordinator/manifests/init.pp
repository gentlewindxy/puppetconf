class coordinator{
	$source_repo="puppet://${puppetserver}/files/coordinator"
	$target_dir="/usr/local/arcsoft/coordinator"
	$package_filename="coordinator.war"
	$script_filename="install.sh"
	$package_dir="/usr/local/tomcat/webapps/ROOT1"
	
	$rabbitmqServer="172.17.193.80"
	$mongodbServer="172.17.193.82"
	
	include 'coordinator::install'
	include 'coordinator::deploy'

	anchor{"coordinator::begin":}
	anchor{"coordinator::end":}
	
	Anchor["coordinator::begin"] -> Class["coordinator::install"] 
		-> Class["coordinator::deploy"]
}

class coordinator::install {
	$source_repo=$coordinator::source_repo
	$target_dir=$coordinator::target_dir
	$package_filename=$coordinator::package_filename
	$script_filename=$coordinator::script_filename

	file { $target_dir:
		ensure => "directory",
	}
	
	file {"${target_dir}/${package_filename}":
		source => "${source_repo}/${package_filename}",
		ensure => present,		
	}
	
	file {"${target_dir}/${script_filename}":
		source => "${source_repo}/${script_filename}",
		ensure => present,
		mode => 666,
	}
}

class coordinator::deploy{	
	$target_dir=$coordinator::target_dir	
	$script_filename=$coordinator::script_filename
	$package_dir=$coordinator::package_dir
	
	exec {"exec-deploy-coordinator":
		command => "sh ${target_dir}/${script_filename}",
		path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
	}
	
	$rabbitmqServer=$coordinator::rabbitmqServer
	$mongodbServer=$coordinator::mongodbServer
	
	file {"${package_dir}/WEB-INF/classes/config/coordinator.properties":
		content => template("coordinator/coordinator.config.erb"),
		require => Exec["exec-deploy-coordinator"],
	}
	
	exec{ "exec-start-tomcat":
		command => "sh /usr/local/tomcat/bin/startup.sh",
		path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
		require => File["${package_dir}/WEB-INF/classes/config/coordinator.properties"],
	}
}