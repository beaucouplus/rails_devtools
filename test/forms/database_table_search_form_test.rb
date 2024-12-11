# frozen_string_literal: true

require "test_helper"
require "minitest/autorun"

module Devtools
  class DatabaseTableSearchFormTest < ActiveSupport::TestCase
    setup do
      @connection = ActiveRecord::Base.connection
    end

    test "finds table matching search term" do
      tables = %w[users posts comments]
      columns = [
        Struct.new(:name).new("id"),
        Struct.new(:name).new("username"),
        Struct.new(:name).new("email")
      ]
      indexes = [
        Struct.new(:name, :columns, :unique).new(
          "index_users_on_email",
          ["email"],
          true
        )
      ]

      @connection.stub(:tables, tables) do
        @connection.stub(:columns, columns) do
          @connection.stub(:indexes, indexes) do
            form = DatabaseTableSearchForm.new(search: "users")
            results = form.results

            assert_equal 1, results.length
            table = results.first
            assert_instance_of DatabaseTableSearchForm::DatabaseTable, table
            assert_equal "users", table.table_name
            assert_equal columns, table.columns

            index = table.indexes.first
            assert_instance_of DatabaseTableSearchForm::ShortIndex, index
            assert_equal "Email", index.name
            assert_equal ["email"], index.columns
            assert_equal true, index.unique
          end
        end
      end
    end

    test "finds table with matching column name" do
      tables = %w[posts comments]
      user_id_columns = [
        Struct.new(:name).new("id"),
        Struct.new(:name).new("user_id")
      ]
      other_columns = [
        Struct.new(:name).new("id"),
        Struct.new(:name).new("content")
      ]

      @connection.stub(:tables, tables) do
        @connection.stub(:columns, ->(table) { table == "posts" ? user_id_columns : other_columns }) do
          @connection.stub(:indexes, []) do
            form = DatabaseTableSearchForm.new(search: "user")
            results = form.results

            assert_equal 1, results.length
            assert_equal "posts", results.first.table_name
          end
        end
      end
    end

    test "returns all tables when search is empty" do
      tables = %w[users posts]
      columns = [Struct.new(:name).new("id")]

      @connection.stub(:tables, tables) do
        @connection.stub(:columns, columns) do
          @connection.stub(:indexes, []) do
            form = DatabaseTableSearchForm.new(search: "")
            results = form.results

            assert_equal 2, results.length
            assert_equal %w[users posts], results.map(&:table_name)
          end
        end
      end
    end

    test "excludes internal rails tables from results" do
      tables = %w[schema_migrations ar_internal_metadata users]

      @connection.stub(:tables, tables) do
        @connection.stub(:columns, []) do
          @connection.stub(:indexes, []) do
            form = DatabaseTableSearchForm.new(search: "")
            results = form.results

            assert_equal 1, results.length
            assert_equal ["users"], results.map(&:table_name)
          end
        end
      end
    end

    test "performs case-insensitive search" do
      tables = ["users"]
      columns = [Struct.new(:name).new("ID")]

      @connection.stub(:tables, tables) do
        @connection.stub(:columns, columns) do
          @connection.stub(:indexes, []) do
            form = DatabaseTableSearchForm.new(search: "Users")
            results = form.results

            assert_equal 1, results.length
            assert_equal ["users"], results.map(&:table_name)
          end
        end
      end
    end
  end
end
