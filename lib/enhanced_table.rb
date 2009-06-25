require File.join(File.dirname(__FILE__), 'html_table_builder')
require File.join(File.dirname(__FILE__), 'result_manipulator')

class EnhancedTable

  EMPTY_QUERY_ERROR_MESSAGE =
          "<p>Must specify 'query' parameter for table macro. </p>"

  def initialize(parameters, project, current_user)
    @parameters = parameters
    @project = project
    @current_user = current_user
  end

  def execute
    query = @parameters['query']
    renaming_param = @parameters['rename']
    calculation_param = @parameters['calculate']
    
    if query == nil
      return EMPTY_QUERY_ERROR_MESSAGE
    end

    mql_result = @project.execute_mql(query)

    if mql_result.empty?
      return "<p>query <pre><code> " + query + " </code></pre> does not return any result</p>"
    end

    begin
      manipulated_result = ResultManipulator.process(mql_result, renaming_param, calculation_param)
    rescue ArgumentError => exception
      return "<p>" + exception.message + "</p>"
    end

    return HtmlTableBuilder.build_table_from(manipulated_result, @project)
  end

  def can_be_cached?
    false  # if appropriate, switch to true once you move your macro to production
  end

end

