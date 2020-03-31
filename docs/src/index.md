The `EcologicalNetworksPlots` package extends `EcologicalNetworks` to provide
plotting functionalities, by allowing network objects to be used with `Plots`.
This documentation has a complete reference of the functions and types, as well
as a gallery of examples.

Plotting a network can be done in two ways. First, as a `heatmap`, in which case
no arguments are necessary. Second, as the usual nodes and links visualization.

The second option requires to set a layout, of which there are multiple types
according to the type of network, the type of layout, and the information to
emphasize. Applying a layout consists of a call to `initial`, followed by one or
more calls to `position!`. The *nodes* in the network are represented using
`scatter`, and the *links* using `plot`.

Probabilistic networks have link *probability* denoted as transparency, and
quantitative network have link *strength* represented as width.
