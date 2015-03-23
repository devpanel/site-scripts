var casper = require('casper').create({
//    verbose: true,
//    logLevel: "debug"
});
casper.options.waitTimeout = 70000;
var x = require('casper').selectXPath;
casper.options.viewportSize = {width: 1366, height: 667};
casper.start('https://uptimerobot.com/login');

casper.then(function(){
  this.fillSelectors('body', {
    'form input#userEmail':    '#user_name#',
    'form input#userPassword':    '#user_password#'
  }, false);
   this.echo('Filled name and password');
});

casper.then(function(){
  this.echo('Clicking on the submit button.');
  this.click(".heeyy");
});

casper.wait(10000);

casper.then(function() {
   this.echo('Clicking on settings button.');
   this.click(x("//*[@id='headerMenu']/li[3]/a"));
});

casper.wait(3000);

casper.then(function() {
    var createButtonVisible = casper.evaluate(function() {
        $('.showMainAPIKey').click();
        if ($('#createMainAPIKeyButton').is(':visible')) {
            return true;
        } else {
            return false;
        }
    });
    this.echo('Create api key button is visible - ' + createButtonVisible);

    if (createButtonVisible == false) {
        var apiKey = casper.evaluate(function() {
            return  document.getElementById("mainAPIKeyValue").innerHTML;
        });
    } else {
        this.evaluate(function() {
            $('#createMainAPIKeyButton').click();
        });
    }
});

casper.thenOpen('https://uptimerobot.com/dashboard#mySettings');
casper.wait(3000);

casper.then(function() {
    var apiKey = casper.evaluate(function() {
        return  document.getElementById("mainAPIKeyValue").innerHTML;
    });
    this.echo(apiKey);
    var fs = require('fs');
    fs.write('apiKey', apiKey, 'w');
});          
casper.run();