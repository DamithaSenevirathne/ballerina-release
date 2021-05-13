#!./test-libs/bats/bin/bats
# ---------------------------------------------------------------------------
#  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

load '../libs/bats-support/load'
load '../libs/bats-assert/load'

@test "Create project '$PACKAGE_NAME:$VERSION' from 1.2.x." {
  run $B12X/bin/ballerina new $PACKAGE_NAME
  assert_line --partial "Created new Ballerina project at $PACKAGE_NAME"
  [ "$status" -eq 0 ]
  mv $PACKAGE_NAME "$PACKAGE_NAME-$VERSION"
  local current_user=$(whoami);
  cd "$PACKAGE_NAME-$VERSION"
  sed -i'.original' -e "s/$current_user/$TEST_ORGANIZATION/g" "Ballerina.toml"
  sed -i'.original' -e "s/0.1.0/$VERSION/g" "Ballerina.toml"
  rm "Ballerina.toml.original"
  echo '# Sample github package' > "Package.md"
  cd -
}

@test "Add new module to '$PACKAGE_NAME:$VERSION' from 1.2.x." {
  cd "$PACKAGE_NAME-$VERSION"
  run $B12X/bin/ballerina add $PACKAGE_NAME
  assert_line --partial "Added new ballerina module at 'src/$PACKAGE_NAME'"
  [ "$status" -eq 0 ]
  cd -
}

@test "Build module '$PACKAGE_NAME:$VERSION' from 1.2.x" {
  cd "$PACKAGE_NAME-$VERSION"
  run $B12X/bin/ballerina build $PACKAGE_NAME
  assert_line --partial "target/bin/$PACKAGE_NAME.jar"
  [ "$status" -eq 0 ]
  cd -
}
