require 'spec_helper'

describe Resource do
  context 'when the resource is locked by someone else' do
    let!(:resource) { Resource.new(name: 'locked-resource', locked_by: 'someone-else', locked_until: (Time.now + 600)) }

    describe '#lock' do
      it 'returns false' do
        expect(resource.lock('me', 5)).to be_falsey
      end
    end

    describe '#status_string' do
      it 'describes the status and duration of the lock' do
        expect(resource.status_string).to eq 'locked-resource is locked by someone-else for another 10 minutes'
      end
    end
  end

  context 'when the resource is locked by the user requesting the lock' do
    let!(:resource) { Resource.new(name: 'locked-resource', locked_by: 'me', locked_until: (Time.now + 600)) }

    describe '#lock' do
      before do
        resource.lock('me', 5)
      end

      it 'resets the lock to the new time' do
        expect(resource.locked_until < (Time.now + 305)).to be_truthy
      end
    end
  end

  context 'when the resource is unlocked' do
    let!(:resource) { Resource.new(name: 'locked-resource') }

    describe '#lock' do
      before do
        resource.lock('me', 5)
      end

      it 'sets the lock 5 minutes out' do
        expect(resource.locked_until < (Time.now + 300)).to be_truthy 
      end

      it 'is locked by the user requesting the lock' do
        expect(resource.locked_by).to eq 'me'
      end
    end

    describe '#status_string' do
      it 'says the resource is not locked' do
        expect(resource.status_string).to eq 'locked-resource is not locked'
      end
    end
  end
end
