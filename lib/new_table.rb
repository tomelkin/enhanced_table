require File.join(File.dirname(__FILE__), 'html_table_builder')

class NewTable

  EMPTY_QUERY_ERROR_MESSAGE =
          "<p>Must specify 'query' parameter for table macro. </p>"

  def initialize(parameters, project, current_user)
    @parameters = parameters
    @project = project
    @current_user = current_user
  end

  def execute
    query = @parameters['query']
    renaming_param = @parameters['renaming_param']

    if query == nil
      return EMPTY_QUERY_ERROR_MESSAGE
    end

    mql_result = @project.execute_mql(query)

    if mql_result.empty?
      return "<p>query <pre><code> " + query + " </code></pre> does not return any result</p>"
    end

    return HtmlTableBuilder.build_table_from(mql_result, @project, renaming_param)
  end

  def can_be_cached?
    false  # if appropriate, switch to true once you move your macro to production
  end

end

