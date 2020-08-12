Extension { #name : #IceTipInteractiveErrorVisitor }

{ #category : #'*Lazygun-Patches' }
IceTipInteractiveErrorVisitor >> titleText: aString forError: anError [
	"Answer with a string to be used as the title of a notification dialog.
	If the error provides description of the cause, use that in the title."
	
  ^ aString, (anError errorText ifNotNil: [ :cause | ': ', cause ] ifNil: String empty)
]

{ #category : #'*Lazygun-Patches' }
IceTipInteractiveErrorVisitor >> visitAuthenticationError: anError [
	UIManager default 
		alert: anError messageText
		title: (self titleText: 'Iceberg authentication Error' forError: anError)
]

{ #category : #'*Lazygun-Patches' }
IceTipInteractiveErrorVisitor >> visitCheckoutConflict: anError [
	UIManager default 
		alert: anError messageText
		title: (self titleText: 'Iceberg conflicts while checking out' forError: anError)
]
