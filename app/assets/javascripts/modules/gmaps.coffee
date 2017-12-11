init = ->
  location_input = document.getElementById('GenericForm-locations-new_locations__street')
  
  if location_input
    # autocomplete settings
    options =
      bounds: new google.maps.LatLngBounds(
        new google.maps.LatLng(53, 14),
        new google.maps.LatLng(52, 12.5)
      )
      types: ['geocode']
      language: 'de'
      componentRestrictions:
        country: 'de'
    
    # instantiate autocomplete field
    autocomplete =
      new google.maps.places.Autocomplete location_input, options

    autocomplete.addListener('place_changed', fillInAddress)

    # MORE CALLBACKS

    # register event listener that pushes to GA when field is changed
    # When place_changed is fired, also fire the event on the form element,
    # so other scripts can hook into that
    # google.maps.event.addListener(
    #   Clarat.PlacesAutocomplete.instance, 'place_changed',
    #   @handleGooglePlaceChanged
    # )


fillInAddress = ->
  #debugger
  # Get the place details from the autocomplete object.
  place = autocomplete.getPlace()
  #debugger

$(window).load init