autoload :ERB, 'erb'
autoload :Find, 'find'
autoload :ChildProcessHelper, 'child_process_helper'
autoload :Byebug, 'byebug'

class Runner
  def initialize(project)
    @project = project
  end

  attr_reader :project

  def tut
    prepare

    ChildProcessHelper.check_call(%w(make html), cwd: project)
  end

  def build
    prepare

    ChildProcessHelper.check_call(%w(make publish), cwd: project)
  end

  def deploy
    prepare

    ChildProcessHelper.check_call(%w(make publish deploy), cwd: project)
  end

  private

  def prepare
    # Giza insists on being run in a git repo. Could consider patching this
    # out of giza instead of working around here.
    [
      %w(git init),
      %w(git config --global user.name Nobody),
      %w(git config --global user.email nobody@example.com),
      %w(git commit --allow-empty -mRoot),
    ].each do |cmd|
      ChildProcessHelper.check_call(cmd, cwd: project)
    end

    if File.exist?('.src')
      ChildProcessHelper.check_call(%w(git init), cwd: '.src')
      ChildProcessHelper.check_call(%w(git add .), cwd: '.src')
      ChildProcessHelper.check_call(%w(git commit -m source), cwd: '.src')
    end

    Find.find("#{project}/config") do |path|
      if path.end_with?('.erb')
        puts "Transforming #{path}"
        template = File.read(path)
        erb = ERB.new(template)
        result = erb.result(get_binding)
        File.open(path.sub(/\.erb\z/, ''), 'w') do |f|
          f << result
        end
      end
    end
  end

  def get_binding
    binding
  end
end
