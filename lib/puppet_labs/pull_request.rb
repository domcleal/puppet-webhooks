require 'json'
require 'puppet_labs/github_mix'

# This class provides a model of a pull rquest.
module PuppetLabs
class PullRequest
  include GithubMix
  # Pull request data
  attr_reader :number,
    :env,
    :repo_name,
    :title,
    :html_url,
    :body,
    :action,
    :message

  def self.from_json(json)
    new(:json => json)
  end

  def initialize(options = {})
    if json = options[:json]
      load_json(json)
    end
    if env = options[:env]
      @env = env
    else
      @env = ENV.to_hash
    end
  end

  def load_json(json)
    data = JSON.load(json)
    @message = data
    @number = data['pull_request']['number']
    @title = data['pull_request']['title']
    @html_url = data['pull_request']['html_url']
    @body = data['pull_request']['body']
    @repo_name = data['repository']['name']
    @action = data['action']
  end

  def created_at
    message['pull_request']['created_at']
  end

  def author
    message['sender']['login']
  end

  def author_avatar_url
    message['sender']['avatar_url']
  end
end
end
