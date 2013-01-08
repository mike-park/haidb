# copied from https://gist.github.com/2036895
# from rails issue https://github.com/rails/rails/pull/3795#issuecomment-3549669
# disable logging of asset calls in development
Rails::Rack::Logger.class_eval do
  def call_with_silenced_logger(env)
    if Rails.env.development? && env['QUERY_STRING'] =~ /body=1/iomx
      begin
        a = Rails.logger.level
        b = ActionController::Base.logger.level
        Rails.logger.level = Logger::FATAL
        ActionController::Base.logger.level = Logger::FATAL
        call_without_silenced_logger(env)
      ensure
        Rails.logger.level = a
        ActionController::Base.logger.level = b
      end
    else
      call_without_silenced_logger(env)
    end
  end

  alias_method_chain(:call, :silenced_logger)
end
