require File.join(File.dirname(__FILE__), 'html_table_builder')
require File.join(File.dirname(__FILE__), 'table_processor')
require File.join(File.dirname(__FILE__), 'property_definition_loader')

class
EnhancedTable

  EMPTY_QUERY_ERROR_MESSAGE =
          "<p>Must specify 'query' parameter for table macro. </p>"

  EMPTY_RESULT_ERROR_MESSAGE = "<p>query <pre><code>%s</code></pre> does not return any result</p>"

  def initialize(parameters, project, current_user)
    @parameters = parameters
    @project = project
    @current_user = current_user
  end

  def execute

    html = ""
    query = @parameters['query']
    renaming_param = @parameters['rename']
    calculation_param = @parameters['calculate']

    if query == nil
      return EMPTY_QUERY_ERROR_MESSAGE
    end

    mql_results = @project.execute_mql(query)

    if mql_results.empty?
      return EMPTY_RESULT_ERROR_MESSAGE % query
    end


    begin
      table = Table.new(mql_results, @project)
      TableProcessor.process(table, renaming_param, calculation_param)
    rescue Exception => exception
      return "<p>" + exception.message + "</p>"
    end

    html_table = HtmlTableBuilder.build_html_table_from(table)
    return html_table
  end

  def can_be_cached?
    false  # if appropriate, switch to true once you move your macro to production
  end

end

