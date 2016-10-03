#/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'ipaddress'
require 'logger'


@const_error_logs = Logger.new("../var/construction_error.log", 'weekly')
@const_logs = Logger.new("../var/construction.log", 'weekly')

  def json_parser
    file_location="../constructor/main.fc"
    check = File.exist?("#{file_location}")
    if check == true
      @const_logs.info("File main.fc found")
      reader = File.read("#{file_location}")
      data = JSON.parse(reader)
      data
    else
      puts "ERROR -- main.fc does not exist"
      @const_error_logs_logs.fatal("fer_theconstructor/constructor/main.fc does not exist")
    end
  end

  def host_checker
    hostname = ""
    data = json_parser
    host_values = data['constructor']
    host_values.each do |names|
      result = names['host']
      @const_logs.info('Checking if "host" resource exist')
      if result
      @const_logs.info('"host" resource found -- Validating hostname')
        if result.match(/^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/)
        @const_logs.info("host: #{result} -- Validated")
          hostname = result
        elsif IPAddress.valid?"#{result}"
          @const_logs.info("IP: #{result} validated")
           hostname = result
        else
          puts "ERROR -- Wrong hostname"
          @const_error_logs_logs.error("Wrong Hostnanme/IPaddress: #{result}")
          exit 1
        end
      else
        puts "ERROR -- Missing Host resource"
        puts "You can define this by adding \"host\": \"<name|ipaddress>\""
        @const_error_logs_logs.fatal('Missing "host" resource')
        exit 1
      end
      hostname
    end
  end
  
  def action
    arguments = ""
    file_values = json_parser
    action_todo = file_values['constructor']
    action_todo.each do |doing|
      action = doing['action']
      if action
        @const_logs.info('"action" Resource Found -- Checking Option')
        if action == "install"
          @const_logs.info('Option "install" Selected')
          arguments = "#{action}"
        elsif action == "remove"
          @const_logs.info('Option "removed" Selected')
          arguments = "#{action}"
        else
          puts "No Action Selected"
          @const_error_logs_logs.error('No Option Selected')
        end
      else
        puts "ERROR -- Missing action resource"
        puts "You can define this by adding \"action\": \"<intall/remove>\""
        @const_error_logs_logs.fatal('Missing "action" resource')
        exit 1
      end
      arguments
    end
  end

  def letmeknow
    status = ""	  
    file_values = json_parser
    notifyserv = file_values['constructor']
    notifyserv.each do |informing|
      result = informing['notify']
      if result
        @const_logs.info('Resource "notify" Found -- Verifying Option')
        if result == "yes"
          @const_logs.info('Option "yes" Selected')
          status = "yes" 
        elsif result == "no"
          @const_logs.info('Option "no" Selected')
          status = "no"
        else
          puts "Notify Option Cannot Be Determine"
          @const_error_logs_logs.fatal('No Option Selcted')
          puts "Available Options \"<yes|no>\""
        end
      else
        puts "ERROR -- Missing notify resource"
          @const_error_logs_logs.fatal('Missing "notify" resource')
        exit 1
      end
      puts status      
    end
  end

  def package
    package = ""
    file_values = json_parser
    pckg = file_values['constructor']
    pckg.each do |whichone|
      result = whichone['package']
      @const_logs.info('Resource "package" Found')
      if result
        @const_logs.info("Package #{result} Selected to be Install or Removed")
        package = result
      else
        puts "ERROR -- Missing package resource"
        puts "You can define this by adding \"package\": \"<package_name>\""
        @const_error_logs_logs.fatal('Missing "package" resource')
        exit 1
      end
      puts package  
    end      
  end

  def controller
    argline = ""
    data = json_parser
    values = data['constructor']
    puts "Starting Deployment"
    sleep 2
    values.each do |inputs|
      host_input = inputs['host']
      package_input = inputs['package']
      notify_input = inputs['notify']
      action_input = inputs['action']
      argline = "#{package_input} #{action_input} #{notify_input} #{host_input}"
      command=`sh ./remote_pack_deploy.sh #{argline}`
      puts command
      sleep 2
    end
  end


controller



