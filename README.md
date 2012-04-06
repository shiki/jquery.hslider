
jquery.hslider
------------------------

A jQuery plugin, this is a base utility for creating user interfaces with horizontal sliding. 
This prepares a list of elements, with ".pages" as classes, for horizontal scrolling. Scrolling
can then be controlled by calling `selectIndex`. This allows developers to implement
their own UI. 

### Usage

This expects a HTML setup like this:

    <div id="container">
      <ul class=".pages">
        <li class=".page"> <!-- your content here --> </li>
        <li class=".page"> <div class="your-content"></div> </li>
      </ul>
    </div>

To set it up:

    $('#container').hslider({
      easing: 'easeInOutCubic' // define the easing function to use
      duration: 400 // animation durations
    });

Once you have the container set up for horizontal sliding, you can control 
what page to slide to using this:

    $('#container').hslider('instance').selectIndex(1);
 
Passing a boolean for the second parameter in `selectIndex` will instruct the slider to
animate or not.

### Notes

This is written in CoffeeScript but the compiled JavaScript (`jquery.hslider.js`) is included in the repo.