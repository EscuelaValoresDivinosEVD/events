class Lodging.Views.ParticipantsNewEdit extends Backbone.View

	el: 'body'

	events:
		"change .modality_select": 'populateSpacesList'
		"click #clean-guest-input-btn": 'cleanTokenInput'
		#"submit form.new_participant, submit form.edit_participant": 'validateGuestBillingData'
		
	initialize: ->
		$('#participant_guest_id').tokenizeInput()
		
		if typeof $('#participant_guest_id').data('guest') isnt "undefined" && $('#participant_guest_id').data('guest') isnt null && $('#participant_guest_id').data('guest') isnt ''
			guest = $('#participant_guest_id').data('guest')
			$('#token-input-participant_guest_id').val(guest.name + " " + guest.surname + " (" + guest.email + ")")
			$('#token-input-participant_guest_id').attr('readonly', 'readonly')
			$('#token-input-participant_guest_id').addClass('token-occupied')
			$('#participant_guest_id').val(guest.id)
			@setSelectedGuest(guest)
			
		$('#token-input-participant_guest_id').attr('required', 'required')
		
		@modalities = new Lodging.Collections.Modalities()
		@modalities.reset(gon.modalities)

	validateGuestBillingData: (event) ->
		@refreshSelectedGuestData()
		missingFields = @missingBillingFields()
		return true if missingFields.length is 0
		event.preventDefault()
		@showMissingBillingDataModal(missingFields)
		false

	refreshSelectedGuestData: ->
		guest = @selectedGuestData()
		guestId = guest?.id || $('#participant_guest_id').val()
		return unless guestId?
		completeGuest = guest
		$.ajax(
			url: "/guests/#{guestId}.json"
			type: 'GET'
			async: false
			success: (data) ->
				console.log('guest completo', data)
				completeGuest = data
		)
		@setSelectedGuest(completeGuest) if completeGuest?

	missingBillingFields: ->
		requiredFields = [
			{keys: ['identification'], label: 'identificación'}
			{keys: ['mobile_number'], label: 'número de celular'}
			{keys: ['name'], label: 'nombre'}
			{keys: ['surname', 'last_name'], label: 'apellido'}
			{keys: ['email'], label: 'correo electrónico'}
			{keys: ['country'], label: 'país de residencia'}
			{keys: ['city'], label: 'ciudad'}
		]
		guest = @selectedGuestData()
		console.log guest
		return requiredFields.map((field) -> field.label) unless guest?
		requiredFields.filter((field) =>
			@isMissingGuestField(guest, field.keys)
		).map((field) -> field.label)

	isMissingGuestField: (guest, keys) ->
		foundKey = false
		for key in keys
			if Object::hasOwnProperty.call(guest, key)
				foundKey = true
				return String(guest[key] || '').trim() is ''
		!foundKey

	showMissingBillingDataModal: (missingFields) ->
		$('#missing-guest-billing-data-fields').text("Campos faltantes: #{missingFields.join(', ')}.")
		guest = @selectedGuestData()
		if guest? and guest.id?
			$('#missing-guest-billing-data-edit-link').attr('href', "/guests/#{guest.id}/edit")
		else
			$('#missing-guest-billing-data-edit-link').attr('href', '/guests')
		$('#missing-guest-billing-data-modal').modal('show')

	selectedGuestData: ->
		tokenInputField = $('#participant_guest_id')
		selectedFromToken = null
		try
			selectedTokens = tokenInputField.tokenInput('get')
			selectedFromToken = selectedTokens[0] if selectedTokens? and selectedTokens.length > 0
		catch error
			selectedFromToken = null
		tokenInputField.data('selectedGuest') || selectedFromToken || tokenInputField.data('guest')

	setSelectedGuest: (guest) ->
		$('#participant_guest_id').data('selectedGuest', guest)
		
	populateSpacesList: (event) ->
		modality_id = event.target.value
		participantSelect = $(event.target).closest('.fields').find('.space_select')
		if modality_id is ''
			participantSelect.attr('disabled', 'disabled')
			participantSelect.val('')
			participantSelect.trigger('change')
		else
			participantSelect.removeAttr('disabled')
			participantSelect.html('<option value=""></option>')
			participantSelect.trigger('change')
			participantSelect.addClass('active-space')
			@modality = @modalities.get(modality_id)
			@spaces = new Lodging.Collections.Spaces()
			@spaces.reset(@modality.get('spaces'))
			@spaces.each(@appendSpaceOption)
			participantSelect.removeClass('active-space')
	
	cleanTokenInput: () ->
		$('#token-input-participant_guest_id').removeClass('token-occupied')
		$('#token-input-participant_guest_id').val('')
		$('#token-input-participant_guest_id').focus()
		$('#participant_guest_id').val('')
		@setSelectedGuest(null)
		
	appendSpaceOption: (space)->
		console.log space
		view = new Lodging.Views.SpacesOption(model: space)
		$('.active-space').append(view.render().el)
		
	$.fn.tokenizeInput = ->
		tokenizeField = $(this)
		tokenizeField.tokenInput('/guests.json', {
			crossDomain: false,
			propertyToSearch: ["name", "surname", "email"]
			hintText: "Buscar por nombre o email"
			noResultsText: "No results"
			insertText: "No existe: Adicionar Contacto"
			insertUrl: '/guests/new'
			insertParam: 'email'
			resultsLimit: 1
			uniqueSelection: true
			placeholder: $('#booking_guest_id').attr('placeholder')
			selectionFormat: (item) ->
				return "#{item.name} #{item.surname} (#{item.email})"
			resultsFormatter: (item) ->
				return "<li>" + "<div class='token-result-wrapper'><div>" + item.name + " " + item.surname + "</div><div>" + item.email + "</div></div></li>"
			onAdd: (item) ->
				$('#participant_guest_id').data('selectedGuest', item)
			onDelete: () ->
				$('#participant_guest_id').data('selectedGuest', null)
		})
		
	