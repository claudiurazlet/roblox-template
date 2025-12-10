-- Type definitions for TestEZ globals
-- These are injected at runtime by TestEZ's TestBootstrap

declare function describe(phrase: string, callback: () -> ()): ()
declare function it(phrase: string, callback: () -> ()): ()
declare function expect(value: any): any
declare function beforeAll(callback: () -> ()): ()
declare function beforeEach(callback: () -> ()): ()
declare function afterAll(callback: () -> ()): ()
declare function afterEach(callback: () -> ()): ()
declare function FIXME(optionalMessage: string?): ()
declare function FOCUS(): ()
declare function SKIP(): ()
declare describeFOCUS: typeof(describe)
declare describeSKIP: typeof(describe)
declare itFOCUS: typeof(it)
declare itSKIP: typeof(it)
declare itFIXME: typeof(it)
