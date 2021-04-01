Class {
	#name : #LGSnippets,
	#superclass : #Object,
	#category : #Lazygun
}

{ #category : #epicea }
LGSnippets class >> replayAllChangesForPackage: aPackageName [
	"To walk all the Epicea change store (ombu), and replay all the code changes that affected a particular package.
This one is useful if you want to reconstruct the state that a package was in in previous image, but don't have the changes in a Metacello repository."
	| events logs |
	events := OrderedCollection new.
	logs := EpMonitor current sessionStore directory files sorted: [ :a :b | a modificationTime < b modificationTime ].
	logs
		collect: [ :file | EpLog fromFile: file ]
		thenDo: [ :log |
			| changes |
			changes := log events select: [ :event |
				event isCodeChange and: [ event affectedPackageName = aPackageName ]].
			events addAll: changes].
	events do: [ :event | event applyCodeChange ]
]
