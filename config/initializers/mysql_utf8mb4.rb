# Use it when your project is backed with mysql utf8mb4 encoding
#
# require 'active_record/connection_adapters/abstract_mysql_adapter'

# module ActiveRecord
#   module ConnectionAdapters
#     class AbstractMysqlAdapter
#       NATIVE_DATABASE_TYPES[:string] = { :name => "varchar", :limit => 191 }
#     end
#   end
# end