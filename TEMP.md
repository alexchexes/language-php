Yep proceed with implementation but with one remark regarding this:

>fixture-aware disabled-symbol parsing from comment lines (; name ...) and use that both for coverage and near-miss filtering

Let's split concerns: known symbols lists must stay as pure input symbols list (where commented-out lines are treated the same as if they were not there - so that nothing breaks if we remove them tomorrow) and, if we need exclusions by fixture, let's make it separate and clear. For example, we could add it as a new key in the target in `targets` in the spec.

Proceed with implementation and feel free to use `request_user_input` any moment if anything unclear or you have a better option.