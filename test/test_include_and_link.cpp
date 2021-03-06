#include <mysql.h>
#include <boost/optional.hpp>
#include <boost/thread.hpp>

#include <cppconn/driver.h>

void foo()
{

}

int main()
{
	// test mysql
	MYSQL mysql;
	if(mysql_init(&mysql)) {
		mysql_close(&mysql);
	}


	// test boost
	boost::optional<int> oi(4);

	auto t = boost::thread{ &foo };
	t.join();

	// test mysqlcppconn

	auto driver = get_driver_instance();

	return 0;
}
