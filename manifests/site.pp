import "nodes.pp"

node default {
#	include transcoder		
#	include coordinator
#	include admin::augeas
#	include fmagent

	file{ "/tmp/helloword.txt":
		content => "hello",
	}
}


node arcvideo80 {
	#include ganglia

	
}
