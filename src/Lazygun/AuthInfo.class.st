"
I can load secrets (passwords) from a PGP-encrypted 'authinfo' file. Authinfo files are simple credentials stores that follow the ""netrc"" standard. See 'https://www.gnu.org/software/emacs/manual/html_node/auth/Help-for-users.html' for further details.

I rely on the 'gpg' program for decrypting authinfo files. So this must be installed on your system. I use SICommand to run gpg.

The standard location for an authinfo file is '~/.authinfo.gpg'. To read the password for the login 'user' on host 'www.example.com' from an authinfo file in the standard location you would do: 

AuthInfo default machine: 'www.example.com'; login: 'user'; password

I cannot be used to update authinfo credentials, only to read them.
"
Class {
	#name : #AuthInfo,
	#superclass : #Object,
	#instVars : [
		'file',
		'machine',
		'login'
	],
	#category : #Lazygun
}

{ #category : #'instance creation' }
AuthInfo class >> default [
	^ self new file: (FileLocator home / '.authinfo.gpg' ) asFileReference 
]

{ #category : #constants }
AuthInfo class >> gpgCommand [
	^ 'gpg'
]

{ #category : #'instance creation' }
AuthInfo class >> on: aFile [
	^ self new
		file: aFile asFileReference;
		yourself
]

{ #category : #initialization }
AuthInfo >> file: aFileReference [
	file := aFileReference 
]

{ #category : #accessing }
AuthInfo >> login [
	^ login
]

{ #category : #accessing }
AuthInfo >> login: aString [
	login := aString 
]

{ #category : #accessing }
AuthInfo >> machine [
	^ machine
]

{ #category : #accessing }
AuthInfo >> machine: aString [
	machine := aString
]

{ #category : #private }
AuthInfo >> matches: aRecord [
	^ (aRecord at: #machine) = self machine
		and: [ (aRecord at: #login) = self login ]
]

{ #category : #private }
AuthInfo >> notFound [
	self
		error:
			(String
				streamContents: [ :stream | 
					stream << 'No entry found for machine "' << self machine
						<< '" and login "' << self login ])
]

{ #category : #parsing }
AuthInfo >> parse: aString [
	| record tokens quotedStringParser |
	record := Dictionary new: 3.
	tokens := aString splitOn: Character space.
	quotedStringParser := [ :key | 
	[ [ | next |
	next := tokens removeFirst.
	record at: key put: (record at: key) , ' ' , next ]
		doWhileFalse: [ (record at: key) endsWith: '"' ].
	record
		at: key
		put: ((record at: key) trimBoth: [ :char | char = $" ]) ] ].
	{#machine . #login . #password}
		do: [ :key | 
			self assert: tokens removeFirst = key asString.
			record at: key put: tokens removeFirst.
			((record at: key) beginsWith: '"')
				ifTrue: (quotedStringParser value: key) ].
	^ record
]

{ #category : #accessing }
AuthInfo >> password [
	^ (self read
		detect: [ :record | self matches: record ]
		ifNone: [ self notFound ]) at: #password
]

{ #category : #private }
AuthInfo >> read [
	^ (SICommand
		waitForCommand: (self class gpgCommand)
		arguments:
			{'-d'.
			file pathString}) lines
		select: [ :line | line beginsWith: 'machine ' ]
		thenCollect: [ :line | self parse: line ]
]
