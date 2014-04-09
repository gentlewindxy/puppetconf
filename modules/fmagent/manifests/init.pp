class fmagent {
	$source_repo="puppet://${puppetserver}/files/fmagent"
	$target_dir="/usr/local/arcsoft1"
	$package_filename="agent_fm.zip"
	$script_filename="install.sh"	
	$package_dir="${target_dir}/agent_fm"
	$rabbitmqServer="172.17.193.88"
	$restServer="http://172.17.193.82"
	
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

	exec {"exec-install-fmagent":
		command => "sh ${target_dir}/${script_filename}",
		path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
		require =>File["${target_dir}/${package_filename}","${target_dir}/${script_filename}"],
	}
	
	#file {"${package_dir}/conf/agent.properties":
	#	content => template("fmagent/fmagent.config.erb"),
	#	require => Exec["exec-install-fmagent"],
	#}
	
	augeas { "config-fmagent" :
		lens => "Properties.lns",
		incl => "${package_dir}/conf/agent.properties",
		#context => "/files${package_dir}/conf/agent.properties",
		changes => [
			"set agent.rabbitmq.host ${rabbitmqServer}",
			"set agent.coordianator.rest.host ${restServer}",
		],
		require => Exec["exec-install-fmagent"],
	}
	
	exec{ "exec-start-fmagent":
		command => "sh ${package_dir}/bin/startup.sh",
		path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
		#require => File["${package_dir}/conf/agent.properties"],
		require => Augeas["config-fmagent"],
	}
}
