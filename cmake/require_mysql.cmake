function (sanity_require_mysql mysql_version)

    set (latest_version 6.1.6)
	set (versions 6.1.6)
	set (hashes cf0190bace2217d9e6d22e9e4783ae1e)

	if (mysql_version STREQUAL "latest")
		sanity_require_mysql (${latest_version})
	else ()
		if (NOT sanity.mysql.version)
			set(sanity.mysql.version ${mysql_version} CACHE STRING "version of mysql required")
		endif ()

		if (sanity.mysql.version VERSION_LESS mysql_version)
			message (FATAL_ERROR "mysql version ${mysql_version} specified but lower version ${sanity.mysql.version} already built")
		endif()

		list (FIND versions "${sanity.mysql.version}" version_index)
		if (version_index LESS 0)
			message (FATAL_ERROR "unknown version of mysql: ${sanity.mysql.version}")
		endif ()

		set (package_name "mysql-connector-c-${mysql_version}-src")
		set (flag_base ${sanity.source.cache.flags}/)
		set (source_url "https://dev.mysql.com/get/Downloads/Connector-C/${package_name}.tar.gz")
		set (source_gz "${sanity.source.cache.archive}/${package_name}.tar.gz")
		list (GET hashes ${version_index} source_hash)
		file(DOWNLOAD ${source_url} 
			${source_gz} 
			SHOW_PROGRESS
	     	EXPECTED_HASH MD5=${source_hash} 
	     )

	     set (source_tree "${sanity.source.cache.source}/${package_name}")

	     if (NOT EXISTS ${src_tree})
	     	execute_process(
    			COMMAND ${CMAKE_COMMAND} -E tar xzf ${source_gz}
    			WORKING_DIRECTORY ${sanity.source.cache.source}
    			RESULT_VARIABLE res
		    	)
		    if (res)
		    	message(FATAL_ERROR "error in command tar xzf ${source_gz} : ${res}")
		    endif ()
		 endif()

		 set (build_dir ${sanity.target.build}/${package_name})
		file(MAKE_DIRECTORY ${build_dir})
		message(STATUS "executing : ${CMAKE_COMMAND} ${source_tree}")
		message(STATUS "directory : ${build_dir}")
		execute_process(
    		COMMAND ${CMAKE_COMMAND} -DCMAKE_INSTALL_PREFIX=${sanity.target.local} ${source_tree}
    		WORKING_DIRECTORY ${build_dir}
    		RESULT_VARIABLE res
		)
		if (res)
			message (FATAL_ERROR "${CMAKE_COMMAND} ${source_tree} : error code : ${res}")
		endif ()
		execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} -j4 install 
						WORKING_DIRECTORY ${build_dir})




	endif()

endfunction ()