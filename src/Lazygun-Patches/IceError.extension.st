Extension { #name : #IceError }

{ #category : #'*Lazygun-Patches' }
IceError >> errorText [
	"Answer with the message text of my signaler, which should describe my cause."
	
  ^ self signaler ifNotNil: [ :cause | cause messageText ]
]
