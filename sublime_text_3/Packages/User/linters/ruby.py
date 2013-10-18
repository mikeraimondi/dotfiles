from lint import Linter

class Ruby(Linter):
    language = 'ruby'
    cmd = ('/Users/mike/.rvm/bin/rvm-auto-ruby', '-wc')
    regex = r'^.+:(?P<line>\d+):\s+(?P<error>.+)'
