Build Monkey
============

A really simple tool to run your builds


Why Build Monkey?
=============

* Build should be simple
* Build and continuous integration design should not need to depend on a framework
(eg. cruisecontrol.rb on rails, hudson on apache, etc)
* Other build tools do too many things and do them the wrong way - Too many usability issues in getting the information that you need
* Most build tools now have dashboard functionality that has been build on top of them to get to important information fast. Making build monkey just do the job of building allows users to write ui's the way they see fit.
* Building a continuous integration tool on MVC is a bad idea. Continuous integration is just a background job runner with only 2 states for that job - pass/fail. It should concentrate on doing that job well. Any framework of choice can then be used to gather and display statistical information about the build.
* Different teams seem to value build artifacts differently. This design allows the user to design their own way of looking at and getting build feedback and not be limited to what the build tool provides
* Build Monkey will provide a very simple way of accessing raw data for each build. It will also provide with a simple dashboard as an example but nothing prescriptive.
* Simple integration into build pipelines, and aggregation tools - If a project has multiple build tools the dashboard can be designed to consume information from all these build tools and display a more comprehensive detail.
* Built to scale - Build monkey is currently based on DRb and can be scaled to number of processors/machines.

Contributors
============

 * [Sudhindra Rao](http://betarelease.github.com/): Original author
 * [Toby Tripp](http://github.com/ttripp): Original author


