"
I am a Baseline for loading Lazygun using Montecello. See my superclass for instructions on how to use me.
"
Class {
	#name : #BaselineOfLazygun,
	#superclass : #BaselineOf,
	#category : #BaselineOfLazygun
}

{ #category : #configuration }
BaselineOfLazygun class >> setUpIDE [
	| rootFolder |
	rootFolder := FileLocator home / 'PharoData'.
	
	SystemResolver userLocalDirectory: rootFolder.
	
	"Old-style GT"
	GTPlayBook
		cacheDirectory: (rootFolder / 'play-cache') ensureCreateDirectory;
		stashDirectory: (rootFolder / 'play-stash') ensureCreateDirectory.
	
	"Gtoolkit"
	Smalltalk globals
		at: #XdPlaygroundSettings
		ifPresent: [ :cls | cls directory: (rootFolder / 'xdocs') ensureCreateDirectory ].
	
	"Epicea"
	OmSessionStore defaultBaseLocator: rootFolder / 'ombu-sessions'.
	EpMonitor restart.
]

{ #category : #baselines }
BaselineOfLazygun >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ self systemInteractionWith: spec.
			spec
				package: 'Lazygun'
					with: [ spec requires: #('SystemInteraction') ];
				package: 'Lazygun-Patches' ]
]

{ #category : #accessing }
BaselineOfLazygun >> projectClass [ 
	^ MetacelloCypressBaselineProject 
]

{ #category : #dependencies }
BaselineOfLazygun >> systemInteractionWith: spec [
	spec
		baseline: 'SystemInteraction'
		with: [ spec repository: 'github://jecisc/SystemInteraction:v1.0.1/src' ]
]
