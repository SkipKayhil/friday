import { Link as StaticLink } from "preact-router";
import { Match } from "preact-router/match";

// This is mostly copied from a currently unreleased preact-router change
// I modifed it to not include the regular class when link is active, and to not
// include the className style props
export function Link({ class: c, activeClass, ...props }) {
  return (
    <Match path={props.href}>
      {({ matches }) => (
        <StaticLink {...props} class={matches ? activeClass : c} />
      )}
    </Match>
  );
}
