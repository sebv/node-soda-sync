{execFile, spawn, exec} = require 'child_process'

task 'compile', 'Compile All coffee files', ->
  compileAll()

task 'compile:watch', 'Compile All coffee files and watch for changes', ->
  compileAll true

task 'clean', 'Remove all js files', ->
  cleanAllJs()

task 'test', 'Run All tests', ->
  testDir 'test' 

task 'grep:dirty', 'Lookup for debugger and console.log in code', ->
  grepDirty()
  
compileAll = (watch = false) ->
  compileCoffee ['lib','test'], ['index.coffee'], watch

cleanAllJs =  ->
  cleanJs ['lib','test'], ['index.js']

compileCoffee = (dirs , files , watch = false) ->    
  params = ['--compile']
  params.push('--watch') if watch
  params = params.concat dirs 
  params = params.concat files
  _spawn 'coffee', params

testDir = (dir) ->    
  execFile 'find', [ dir ] , (err, stdout, stderr) ->
    files = (stdout.split '\n').filter( (name) -> name.match /.+\-test.coffee/ )
    params = ['-R', 'spec', '--colors'].concat files
    _spawn 'mocha', params

cleanJs = (dirs , files) ->
  execFile 'find', dirs.concat(files) , (err, stdout, stderr) ->
    _files = (stdout.split '\n').filter( (name) -> name.match /.+\.js/ )
    _spawn 'rm', _files, false
  
grepDirty = (dirs , word) ->
  execFile 'find', [ '.' ] , (err, stdout, stderr) ->
    files = (stdout.split '\n')\
      .filter( (name) -> not name.match /\/node_modules\//)\
      .filter( (name) -> not name.match /\/\.git\//)\
      .filter( (name) -> 
        ( name.match /\.js$/) or 
        (name.match /\.coffee$/ ) )
    _spawn 'grep', (['console.log'].concat files), false 
    _spawn 'grep', (['debugger'].concat files), false

_spawn = (cmd,params,exitOnError=true) ->
  proc = spawn cmd, params
  proc.stdout.on 'data', (buffer) -> process.stdout.write buffer.toString()
  proc.stderr.on 'data', (buffer) -> process.stderr.write buffer.toString()
  proc.on 'exit', (status) ->
    process.exit(1) if exitOnError and status != 0
