Extension { #name : #IceSshCredentials }

{ #category : #'*Lazygun-Patches' }
IceSshCredentials >> username: anObject [
	username := anObject.
	
	self storeIfDefault.
]
