require File.join(File.dirname(__FILE__), 'html_table_builder')
require File.join(File.dirname(__FILE__), 'table_processor')
require File.join(File.dirname(__FILE__), 'property_definition_loader')

class
EnhancedTable

  EMPTY_QUERY_ERROR_MESSAGE =
          "Must specify 'query' parameter for table macro."

  EMPTY_RESULT_ERROR_MESSAGE = "query <pre><code>%s</code></pre> does not return any result"

  INVALID_COLOR_OPTION_ERROR_MESSAGE = "'%s'. Valid options are 'off', 'text', or 'background'"

  def initialize(parameters, project, current_user)
    @parameters = parameters
    @project = project
    @current_user = current_user
  end


  def execute
    begin
      table = Table.new(mql_results, @project, color_option)
      TableProcessor.process(table, renaming_param, calculation_param)
      html_table = HtmlTableBuilder.build_html_table_from(table)
      return html_table
    rescue Exception => exception
      return "<p>" + exception.message + "</p>"
    end
  end

  def can_be_cached?
    false  # if appropriate, switch to true once you move your macro to production
  end

  private

  def query
    query = @parameters['query']
    if query == nil
      raise Exception.new EMPTY_QUERY_ERROR_MESSAGE
    end
    return query
  end

  def mql_results
    mql_results = @project.execute_mql(query)
    if mql_results.empty?
      raise Exception.new EMPTY_RESULT_ERROR_MESSAGE % query
    end
    return mql_results
  end

  def renaming_param
    @parameters['rename']
  end

  def calculation_param
    @parameters['calculate']
  end

  def color_option
    color_param = @parameters['color']
    return :off if color_param == nil

    if %w(off text background).include? color_param
      color_param.to_sym
    else
      raise Exception.new INVALID_COLOR_OPTION_ERROR_MESSAGE % color_param
    end
  end
end

