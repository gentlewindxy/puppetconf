class transcoder {
	$source_repo="puppet://${puppetserver}/files/transcoder"
	$target_dir="/usr/local/arcsoft/arcvideo1"
	$package_filename="transcoder.zip"
	$script_filename="install.sh"

	file { $target_dir:
		ensure => "directory",
	}
	
	file { "${target_dir}/${package_filename}":
		source => "${source_repo}/${package_filename}",
		ensure => present,
	}
	
	file {"${target_dir}/${script_filename}":
		source => "${source_repo}/${script_filename}",
		ensure => present,
		mode => 666,
	}

	exec {"exec-install-transcoder":
		command => "sh ${target_dir}/${script_filename}",
		path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
		require =>File["${target_dir}/${package_filename}","${target_dir}/${script_filename}"],
	}
}
