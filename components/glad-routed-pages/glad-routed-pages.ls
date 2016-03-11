{join, filter, find, map, elem-index, each, reject, tail, lists-to-obj} = Polymer.GladPreludeLs

class GladRoutedPages
  is: \glad-routed-pages
  properties:
    current-route:
      type: Object
      notify: on
  observers: [
    "go_to_page_of(currentRoute)"
  ]
  broadcast: (event, detail)->
    @query-selector \neon-animated-pages .child-nodes
    |> each ~>
      @fire \neon-animation-finish, detail, bubbles: no, node: it
  set_doms: ->
    document.create-element \template
      ..inner-HTML = """
        <neon-animated-pages class="fit" attr-for-selected="name">
        #{
          @routes
          |> map ->
            "<page-#{it.name} name=\"#{it.name}\"></page-#{it.name}>"
          |> join ""
        }
        </neon-animated-pages>
      """
      ..|> @~instance-template |> @~append-child
  go_to_page_of: (route)->
    @query-selector \neon-animated-pages ?.set \selected, route.name
  let_neon_animated_pages_listen: ->
    @listen (@query-selector \neon-animated-pages), \neon-animation-finish, \broadcast
  attached: ->
    @set_doms!
    @let_neon_animated_pages_listen!
    if @current-route? then @go_to_page_of @current-route

|> ( .::) |> Polymer



