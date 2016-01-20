# Layout Tools for Susy

Layout Tools for Susy is a set of handy mixins and functions to structure, organize and access layout settings over multiple breakpoints. Combined with the power of Susy’s grid calculations it allows you to set up responsive grid layouts fast and with ease.

## Table of Contents
* [Installation](#installation)
  * [NPM](#npm)
  * [Bower](#bower)
  * [Bundler](#bundler)
* [How to use](#how-to-use)
  * [Defining layout contexts](#defining-layout-contexts)
  * [Using layout contexts](#using-layout-contexts)
  * [Settings groups](#settings-groups)
  * [Susy settings](#susy-settings)
  * [Base font size and line height](#base-font-size-and-line-height)
  * [Separating layout settings](#separating-layout-settings)
  * [Defining layout breakpoints](#defining-layout-breakpoints)
* [More handy helpers](#more-handy-helpers)
  * [Units](#units)
  * [Typography](#typography)
  * [Colors](#colors)
  * [Constants](#constants)
* [Tips and tricks](#tips-and-tricks)
* [Contribute](#contribute)


## Installation
### NPM
```bash
$ npm install layout-tools-for-susy --save-dev
```
This installs layout tools and Susy. Include tools in your stylesheets like this:
```scss
// file: src/stylesheets/styles.scss
@import '../../node_modules/susy/sass/susy',
        '../../node_modules/layout-tools-for-susy/stylesheets/layout-tools-for-susy';
```

### Bower
```bash
$ bower install layout-tools-for-susy --save-dev
```
This installs layout tools and Susy. Include tools in your stylesheets like this:
```scss
// file: src/stylesheets/styles.scss
@import '../../bower_components/susy/sass/susy',
        '../../bower_components/layout-tools-for-susy/stylesheets/layout-tools-for-susy';
```

### Bundler
Add layout tools to your ```Gemfile```.
```
source 'https://rubygems.org'

gem 'sass', '~>3.4'
gem 'layout-tools-for-susy', '~>0.1'
```
Install.

```bash
$ bundle install
```
Require layout tools and Susy for SASS compilation in your build tools or via command line.

```bash
$ sass --watch src/sass/styles.scss:build/css/styles.css --require=susy --require=layout-tools-for-susy
```
Include Susy and Layout Tools for Susy in your stylesheets.
```sass
// file: src/sass/styles.scss
@import 'susy',
        'layout-tools-for-susy';
```

## How to use
Since Susy2 switched to storing all grid settings in SASS maps, it seems to be quite a good idea to store other basic layout settings the same way. Layout Tools for Susy provides tools to store and access layout settings while making the interaction with SASS maps to a minimum. Let’s see how it’s done.

### Defining layout contexts
The foundation Layout Tools for Susy build on is a SASS map storing the basic layout settings for your Susy setup and more. Here’s an example:
```scss
// Layout settings
$layouts: (
  default: (
    susy: (
      flow: ltr,
      math: fluid,
      output: float,
      gutter-position: after,
      container: auto,
      container-position: center,
      columns: 4,
      gutters: .25,
      column-width: false,
      global-box-sizing: border-box,
      last-flow: to,
      debug: (
        image: hide,
        color: rgba(#66f, .25),
        output: background,
        toggle: top right,
      ),
      use-custom: (
        background-image: true,
        background-options: false,
        box-sizing: true,
        clearfix: false,
        rem: true,
      )
    ),
    base: (
      base__font-size: 14px,
      base__line-height: 18px
    )
  ),
  M: (
    susy: (
      columns: 8
    ),
    base: (
      base__font-size: 18px,
      base__line-height: 24px
    ),
    breakpoint: (
      max-width: 1200px,
      min-width: 801px
    )
  ),
  L: (
    extends: M,
    susy: (
      columns: 12
    ),
    breakpoint: (
      min-width: 1201px
    )
  )
);
// set up and initialize layout tools
@include layout-init($layouts);

```
The root properties of the map $layouts represent the different layout contexts. Layout contexts may be layout variations depending on breakpoints or layout settings specific for e.g. a certain template. There are some important settings that will be defined by default if you don’t set them yourself. The `default` layout will be set up by—you guessed it—default with the properties `susy`—containing Susy’s default settings—and `base`—setting a `base__font-size` and `base__line-height` value. To implement your custom layouts, you have to create your settings map like shown above overriding the defaults and adding additional layout specifications.

#### Using layout contexts
The `default` layout context is the most basic. It will be used everywhere where no other layout context is set (by using the `layout-use` mixin). All other layout contexts extend the `default` context and thus override its settings. If you want to extend a specific context, you can define it using the `extends` property within a layout context’s definition map. In the example above the layout context `L` extends `M`. That means the settings and values you will be working with in the layout context `L` are the result from first merging `M` into `default` and then `L` into the first merge’s result. So within the context of `L` the value of `base__font-size` will be 18px. This behaviour allows you create a sophisticated system of layout settings through controlled inheritance of settings and values.

As said before, after using ```@include layout-init($layouts);``` the `default` layout context is established. Switching to another context is done using the ```layout-use()``` mixin as shown below:
```sass
.body {

  @include type-base($base__font-size, $base__line-height);

  // Switching to layout context 'M' (and beyond)
  @include layout-use(M up) {
    @include type-base($base__font-size, $base__line-height);
    ...
  }

  // Switching to layout context 'L' (and only 'L')
  @include layout-use(L) {
    ...
  }

}
```
In this example we set the styles for the base font size and line height. As in our layout definition the font size is a different one for layout context `M`, we switch contexts and set the styles again. As we defined the breakpoint property for this context, including ```layout-use()``` will create a corresponding media query that wraps the new type settings. As we know that context `L` extends `M` and keeps the font size and line height, we added the `up` keyword to the parameter we passed to the mixin. This causes to remove all max- values from the media query so the type settings will be valid from `M`’s min-width to infinity. Adding the `down` keyword works the other way around.

#### Settings groups
Besides `extends` all properties of a layout context represent settings groups. An example is the pre-defined group `base`. Settings groups store key-value-pairs of specific settings. The value of each setting can be anything you want it to be like e.g. valid css values or any kind of SASS value types. You can create as many settings groups as you want and add settings to existing ones. This allows you to separate and organize your settings like in the example below:
```scss
$layouts: (
  default: (
    susy: (
      ...
    ),
    base: (
      ...
    ),
    nav: (
      item__font-size: 14px,
      item__line-height: 20px,
      item__border-width: 2px
    ),
    footer: (
      ...
    ),
    map-component: (
      ...
    )
  )
)
```

#### Susy settings
The `susy` property represents the Susy settings map. For more information on configuration settings and how to work with Susy, go to: http://susydocs.oddbird.net/en/latest/

#### Base font size and line height
Within a layout context, there will be two global vars available named `$base__font-size` and `$base__line-height`. They are retrieved automatically from the current layout context’s settings. To override them, define the pixel values of your choice for ```base__font-size``` and ```base__line-height``` in your layout contexts’ ```base``` group.

#### Separating layout settings
To give you even more possibilities to modulize your SASS code base, you can keep e.g. component-specific settings with the corresponding styles in separate files and import them where needed. This is done by using the ```layout-extend()``` mixin like shown below:
```scss
// separate file _my-component.scss
// to be imported in your main style file

// Component settings
$my-component: (
  default: (
    my-component: (
      label__font-size: 12px,
      label__line-height: 14px,
      label__border: 1px dotted color-get(rose, dark)
    )
  ),
  M: (
    my-component: (
      ...
    )
  )
);

// Add component settings to layouts
@include layout-extend($my-component);

// Use styles
.my-component {

  &__label {
    // Retrieve settings from current layout context
    $label__font-size: layout-get(my-component, label__font-size);
    $label__line-height: layout-get(my-component, label__line-height);
    $label__border: layout-get(my-component, label__border);
    @include text-context($label__font-size, $label__line-height) {
      font-family: Helvetica, Arial, sans-serif;
      padding: px-to-em(20px, $local__font-size) 0;
      border: $label__border;
    }
  }

  ...
}

```

### Defining layout breakpoints
Layout Tools for Susy make responsiveness easy. You can define breakpoints through adding the breakpoint property to any (but default) layout context like in this mobile first (smallest screen as default) example:
```scss
$layouts: (
  default: (
    susy: (
      ...
    ),
    base: (
      ...
    )
  ),
  M: (
    susy: (
      // new grid settings
      ...
    ),
    base: (
      // new base font size, etc.
      ...
    ),
    breakpoint: (
      (
        min-width: 480px,
        max-width: 800px,
        min-height: 650px
      ),
      (
        min-width: 640px,
        max-width: 800px
      )
    )
  ),
  L: (
    // we keep and grid settings
    extend: M,
    breakpoint: (
      min-width: 801px
    )
  )
)
```
As you can see, it's possible to define a single, simple breakpoint through adding media query properties directly as well as more complex breakpoints by providing multiple media queries as a list. You can just add any media query property value pair you need and even define media types by adding e.g. ```medium: screen``` (default is ```all```). As soon as you apply a layout context by using ```layout-use()```, all content passed into the mixin will be wrapped in a media query generated from your definition. As said before you can manipulate the media queries by passing one of the keywords ```down``` or ```up``` with the context name. Using the mixin within your stylesheets is pretty great, as you can define layout changes right where they belong like this:
```scss
...
.section {
  &--text {
    // retrieve font size and line height from current layout context
    $text__font-size: layout-get(section, text__font-size);
    $text__line-height: layout-get(section, text__line-height);
    @include type-context($text__font-size, $text__line-height) {
      // convert px values to em using list-px-to-em() helper that also comes with Layout Tools
      padding: list-px-to-em((30px 20px 40px), $local__font-size);
    }

    @include layout-use(M) {
      // retrieve font size and line height from new layout context
      $text__font-size: layout-get(section, text__font-size);
      $text__line-height: layout-get(section, text__line-height);
      @include type-context($text__font-size, $text__line-height) {
        padding: list-px-to-em((30px 20px 40px), $local__font-size);
      }      
    }
  }
}
```
That’s it. Easy, isn’t it?

## More handy helpers
Layout Tools for Susy come with some more handy helpers.

### Units
```scss
// Convert px to em
$rem-value: px-to-rem(10px);

// Convert px to em
$em-value: px-to-em(10px, $base__font-size);

// Convert px to percentage
$pc-value: px-to-pc(10px, 100px);

// Convert px values in list to em
$box__margin: 10px auto 40px auto;
margin: list-px-to-em($box__margin);

```

### Typography
Two really useful tools are the mixins called ```type-base``` and ```type-context```. Especially if you are trying to keep everything modular and try to deal with font sizes in a way similar to this approach: https://css-tricks.com/rems-ems/.

The mixin ```type-base()``` will add style definitions for ```font-size``` and ```line-height``` in ```rem``` relatively to the root element’s font size with a pixel fallback. If no parameters are passed it will use the current layout context’s base font size and base line height. If you want to set a custom value, pass in a pixel value for font size and line height. If you pass content into the mixin, the globals $base__font-size, $base__line-height as well as $local__font-size and $local__line-height (more on this in a second) will be set to the new values within the mixins scope. That comes pretty handy if you want to reset the font size within a element or component to make it independent from the environment it will be used in.

```scss
...
body {
  // set base font size and line height in body element
  @include type-base();  
}

.page {

  &__header {
    // retrieve font sizes from layout context
    $header__font-size: layout-get(page, header__font-size);
    $header__line-height: layout-get(page, header__line-height);
    // apply new font size and line height locally and relatively to base values using 'type-context()'
    @include type-context($header__font-size, $header__line-height) {
      // $base__font-size and $base__line-height stay the same
      // $local__font-size and $local__line-height are set to the new values
      // $local__font-size equals $header__font-size in here
      // $local__line-height equals $header__line-height in here
      padding: px-to-em(30px, $local__font-size) 0;
    }
  }
}

.my-component {
  @extends %component;
  // reset font size and line height to custom values
  $component__font-size: layout-get(compontents, component__font-size);
  $component__line-height: layout-get(compontents, component__line-height);
  @include type-base($component__font-size, $component__line-height, false) {
    // Font size and line height values are reset for all content passed into mixin
    // $base__font-size equals $local__font-size equals $components__font-size in here
    // $base__line-height equals $local__line-height equals $components__line-height in here
    padding: px-to-em(10px, $local__font-size) 0;

    &__title {
      // retrieve font size and line height from current layout context
      $title__font-size: layout-get(components, title__font-size);
      $title__line-height: layout-get(components, title__line-height);
      // set relative type context
      @include type-context($title__font-size, $title__line-height) {
        // $base__font-size and $base__line-height stay the same
        // $local__font-size and $local__line-height are set to the new values
        margin-bottom: px-to-em(15px, $local__font-size);

        span {
          @include type-context(.5 * $title__font-size, .5 * $title__line-height) {
            ...
          }
        }
      }
    }
  }
}
```
In the example above the ```type-context``` mixin is used to set new local font sizes and line heights as ```em``` values. In contrast to ```type-base``` the base values ```$base__font-size``` and ```$base__line-height``` won’t be altered within the mixins scope. Multiple type contexts can be embedded into each other and the mixin will take track of the relative font sizes and line heights and the necessary calculations.

### Colors
```scss
// Store colors
// @include color-set($palette, $tone, $value);

// Define complete palette 'blueish'
@include color-set(blueish, (
  bright: #0000fa,
  base: #000077,
  dark: #000042,
  transparent: rgba(#000077, .75)
));
// Add tone to a palette (defined as 'bright' tone of 'blueish' palette)
@include color-set(blueish, bright, #0000fa);

// Get colors
// $val: color-get($palette, $tone);

// Get 'base' tone of 'blueish' palette
color: color-get(blueish);

// Get 'bright' tone of 'blueish' palette
color: color-get(blueish, bright);

```

### Constants
```scss
// Define new constant
@include const('BG_IMG_PATH', '/assets/images/');

// Retrieve constant
background-image: url(const(BG_IMG_PATH) + 'hero_bg.jpg');
```

### Tips and tricks

### Contribute
