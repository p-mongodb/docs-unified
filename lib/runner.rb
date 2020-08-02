autoload :ChildProcessHelper, 'child_process_helper'

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
  end
end
