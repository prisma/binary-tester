const { download } = require('@prisma/fetch-engine')

const version = process.env.FETCH_ENGINE_VERSION || 'latest'

console.log('using @prisma/fetch-engine version', version)

let last = 0

download({
	binaries: {
		'query-engine': '.',
		'migration-engine': '.',
	},
	showProgress: false,
	progressCb: onProgress,
	version,
})

// onProgress rounds float n to a percentage % 10
function onProgress(n) {
  // round by one digit (0.1234 -> 0.1) and display
  const f = Math.round(n * 10) / 10
  if (last !== f) {
    console.log((f * 100) + "%") // e.g. renders 10%
  }
  last = f
}
