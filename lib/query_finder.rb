class QueryFinder
  attr_accessor :records
  
  def initialize(klass, query_params)
    @klass = klass
    process_params(query_params)
  end

  def run
    @records = @klass.constantize.all

    @query_params.each do |query_hash|
      unless sql_comparison_operator(query_hash[:operator])
        raise ::Exceptions::QueryFinderError::OperationInvalid
      end

      query_string = "#{query_hash[:attr]} "\
      "#{sql_comparison_operator(query_hash[:operator])} "\
      "'#{query_hash[:value]}'"

      @records = @records.where(query_string)
    end

    @records
  end

  private

  def process_params(params)
    @query_params = []
    params.each_pair do |attr, val|
      @query_params << process_query_attr_val_pair(attr, val)
    end
  end

  def process_query_attr_val_pair(attr, val)
    query_hash = {}
    query_hash[:attr] = attr
    val_and_operator_arr = val.split(":")
    query_hash[:operator] = val_and_operator_arr[0]

    query_hash[:value] = query_search_val(
      query_hash[:operator],
      val_and_operator_arr[1]
    )

    query_hash
  end

  def query_search_val(operator, val)
    if operator == 'like'
      '%' << val << '%'
    else
      val
    end
  end

  def sql_comparison_operator(key)
    {
        eq: '=',
        like: 'ILIKE',
        gt: '>',
        lt: '<',
    }[key.to_sym]
  end
end
