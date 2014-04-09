class txagent {
	$source_repo="puppet://${puppetserver}/files/txagent"
	$target_dir="/usr/local/arcsoft1"
	$package_filename="agent_tx.zip"
	$script_filename="install.sh"	
	$package_dir="${target_dir}/agent_tx"
	$rabbitmqServer="172.17.193.80"
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

	exec {"exec-install-txagent":
		command => "sh ${target_dir}/${script_filename}",
		path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
		require =>File["${target_dir}/${package_filename}","${target_dir}/${script_filename}"],
	}
	
	file {"${package_dir}/conf/agent.properties":
		content => template("txagent/txagent.config.erb"),
		require => Exec["exec-install-txagent"],
	}
	
	exec{ "exec-start-txagent":
		command => "sh ${package_dir}/bin/startup.sh",
		path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
		require => File["${package_dir}/conf/agent.properties"],
	}
	
	
}
