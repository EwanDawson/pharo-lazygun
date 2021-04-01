Extension { #name : #FileReference }

{ #category : #'*Lazygun' }
FileReference >> findGitRepos [
	"Do a depth-first search of the filesystem based from this reference,
	gathering together all the directories that are git repos"

	| repos |
	repos := OrderedCollection new.
	self isDirectory & self isReadable
		ifFalse: [ ^ repos ].
	self isGitRepo
		ifTrue: [ repos add: self asFileReference ].
	self directories
		reject: [ :dir | dir basename = '.git' ]
		thenDo: [ :dir | repos addAll: dir resolve findGitRepos ].
	^ repos
]

{ #category : #'*Lazygun' }
FileReference >> isGitRepo [
	"Answer true if this file is a readable directory that is a git repository"

	^ self isDirectory
	  and: [ self isReadable
	  and: [ self entries anySatisfy: [ :entry | entry basename = '.git' and: [ (self / '.git' / 'config') exists ] ] ] ]
]
