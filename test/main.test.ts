import {hello} from '../src/main';
import assert from 'assert';

describe('main', function () {
    describe('#hello()', function () {
        it('should return "Hello world!" when name is not passed', function () {
            assert.equal(hello(), "Hello world!");
        });
        it('should return "Hello +{Name}!" when name is passed', function () {
            assert.equal(hello("there"), "Hello there!");
        });
    });
});
