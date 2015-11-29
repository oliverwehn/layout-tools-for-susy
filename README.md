# Layout Tools for Susy

Layout Tools for Susy is a set of handy mixins and functions to structure, organize and access layout settings over multiple breakpoints. Combined with the power of Susy’s grid calculations it allows you to set up responsive grid layouts fast and with ease.

## How to use
Since Susy2 switched to storing all grid settings in SASS maps, it seems to be quite a good idea to store other basic layout settings the same way. Layout Tools for Susy provides tools to store and access layout settings while making the interaction with SASS maps to a minimum. Let’s see how it’s done.

### Defining layouts and putting them to use
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
    typography: (
      base__font-size: 14px,
      base__line-height: 18px
    )
  ),
  M: (
    susy: (
      columns: 8
    ),
    typography: (
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
The root properties of the map $layouts represent the different layout contexts. Layout contexts may be layout variations depending on breakpoints or layout settings specific for e.g. a certain template. There are some important settings that will be defined by default if you don’t set them yourself. The `default` layout will be set up by—you guessed it—default with the properties `susy`—containing Susy’s default settings—and `typography`—setting a `base__font-size` and `base__line-height` value. To implement your custom layouts, you have to create your settings map like shown above overriding the defaults and adding additional layout specifications. 

#### Layout contexts
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
Besided `extends` all properties of a layout context represent settings groups. An example is the pre-defined group `typography`. Settings groups store key-value-pairs of specific settings. The value of each setting can be anything you want it to be like e.g. valid css values or any kind of SASS value types.

#### Susy settings
The `susy` property represents the Susy settings map. For more information on configuration settings and how to work with Susy, go to: http://susydocs.oddbird.net/en/latest/

#### Base font size and line height
Within a layout context, there will be two global vars available named `$base__font-size` and `$base__line-height`. They are retrieved automatically from the current layout context’s settings. To override them, define 


### Layouts and breakpoints

### Typographic contexts

### Colors

### Constants

### Contribute