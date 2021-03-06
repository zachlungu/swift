// RUN: %target-swift-frontend -dump-ast %s 2>&1 | FileCheck %s

func doSomething<T>(_ t: T) {}

// CHECK: func_decl "outerGeneric(t:x:)"<T> type='<T> (t: T, x: AnyObject) -> ()'

func outerGeneric<T>(t: T, x: AnyObject) {
  // Simple case -- closure captures outer generic parameter
  // CHECK: closure_expr type='() -> ()' {{.*}} discriminator=0 captures=(<generic> t) single-expression
  _ = { doSomething(t) }

  // Special case -- closure does not capture outer generic parameters
  // CHECK: closure_expr type='() -> ()' {{.*}} discriminator=1 captures=(x) single-expression
  _ = { doSomething(x) }

  // Special case -- closure captures outer generic parameter, but it does not
  // appear as the type of any expression
  // CHECK: closure_expr type='() -> ()' {{.*}} discriminator=2 captures=(<generic> x)
  _ = { if x is T {} }

  // Nested generic functions always capture outer generic parameters, even if
  // they're not mentioned in the function body
  // CHECK: func_decl "innerGeneric(u:)"<U> type='<U> (u: U) -> ()' {{.*}} captures=(<generic> )
  func innerGeneric<U>(u: U) {}
}
