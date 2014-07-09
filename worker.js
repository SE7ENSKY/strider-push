module.exports = {
  init: function (config, context, cb) {
    if (config.repo &&
        config.branch &&
        config.dir &&
        config.format &&
        config.cert) {
      cb(null, { deploy: function (context, done) {
        temp = require("temp")
        temp.track()
        temp.open("strider-push", function(err, tmpfile){
            if (err) return done(err)
            fs = require("fs")
            fs.writeFile(tmpfile.path, config.cert, function(err){
                if (err) return done(err)
                context.cmd({ command: "bash", args: [
                  __dirname + "/push.sh",
                  tmpfile.path,
                  config.repo,
                  config.branch,
                  context.dataDir + "/" + config.dir,
                  config.format
                ] }, done)
            })
        })
      }})
    } else {
      cb(new Error("Deploy VCS plugin is not properly configured"))
    }
  }
}
