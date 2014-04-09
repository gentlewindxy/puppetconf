import "nodes.pp"

node default {
#	include transcoder		
#	include coordinator
#	include admin::augeas
#	include fmagent

	file{ "/tmp/helloword.txt":
		content => "hello",
	}

ddd
}


node arcvideo80 {
	#include ganglia

	
}
