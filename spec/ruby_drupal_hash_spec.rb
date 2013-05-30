###############################################################################
#   Copyright 2013 Ben Walding
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
###############################################################################
require 'spec_helper'

describe RubyDrupalHash do
  before :each do
    @hasher = RubyDrupalHash.new
  end

  it "verifies a valid password" do
    password = "password1234"
    hash = "$S$DeIZ1KTE.VzRvudZ5.xgOakipuMFrVyPmRdWTjAdYieWj27NMglI"
    @hasher.verify(password, hash).should be_true
  end

  it "does not verify a nil password" do
    password = nil
    hash = "$S$DeIZ1KTE.VzRvudZ5.xgOakipuMFrVyPmRdWTjAdYieWj27NMglI"
    @hasher.verify(password, hash).should be_false
  end

  it "does not verify a blank password" do
    password = ''
    hash = "$S$DeIZ1KTE.VzRvudZ5.xgOakipuMFrVyPmRdWTjAdYieWj27NMglI"
    @hasher.verify(password, hash).should be_false
  end

  it "does not verify a similar password" do
    password = 'password12345'
    hash = "$S$DeIZ1KTE.VzRvudZ5.xgOakipuMFrVyPmRdWTjAdYieWj27NMglI"
    @hasher.verify(password, hash).should be_false
  end

  it "does not verify a similar hash" do
    password = 'password1234'
    hash = "$S$DeIZ1KTE.VzRvudZ5.xgOakipuMFrVyPmRdWTjAdYieWj27NMgl1"
    @hasher.verify(password, hash).should be_false
  end
end